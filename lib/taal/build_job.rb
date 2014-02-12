module Taal
  class BuildJob
    def self.run(build_id)
      build = Build[build_id]

      # Create a temp folder for working
      tmpdir = Dir.mktmpdir

      # Download script inside of tmpdir
      temp_file = download_script(build.script, tmpdir)

      # Execute script inside of tmpdir
      execute_script(temp_file, tmpdir)

      # Delete script
      FileUtils.rm_f(temp_file)

      # Compress content of temp dir
      compressed_file = compress(tmpdir)

      # Upload compressed file to S3
      url = upload(compressed_file)

      # Save url in build
      build.update(url: url)

      # Delete temp working dir
      FileUtils.rm_rf(tmpdir)
    end

    protected

    def self.download_script(uri, tmpdir)
      file = Tempfile.new(SecureRandom.hex(16), tmpdir, 'wb+')
      file << open(uri).read
      file.close
      file.path
    end

    def self.execute_script(file, tmpdir)
      Dir.chdir(tmpdir) do
        Kernel.system("sh #{file}")
      end
    end

    def self.compress(dir)
      filename = "#{SecureRandom.hex(16)}.tar.gz"
      tmpdir = Dir.mktmpdir
      cmd = "tar czf #{filename} -C #{dir} ."
      Dir.chdir(tmpdir) do
        Kernel.system(cmd)
      end
      "#{tmpdir}/#{filename}"
    end

    def self.upload(file)
      filename = File.basename(file)
      AWS::S3::S3Object.store(filename, open(file), S3_BUCKET)
      policy = AWS::S3::S3Object.acl(filename, S3_BUCKET)
      policy.grants = [AWS::S3::ACL::Grant.grant(:public_read)]
      AWS::S3::S3Object.acl(filename, S3_BUCKET, policy)
      AWS::S3::S3Object.url_for(filename, S3_BUCKET, authenticated: false)
    end
  end
end
