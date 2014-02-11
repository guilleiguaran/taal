module SimpleBuilder
  class BuildJob
    def self.run(build_id)
      build = Build[build_id]
      temp_file = download_script(build.script)
      execute_script(temp_file)
    end

    protected

    def self.download_script(uri)
      file = Tempfile.new(SecureRandom.hex(16), Dir.tmpdir, 'wb+')
      file << open(uri).read
      file.close
      file.path
    end

    def self.execute_script(file)
      Kernel.system("sh #{file}")
    end
  end
end
