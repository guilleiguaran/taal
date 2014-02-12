Sequel.connect(ENV["DATABASE_URL"])

AWS::S3::Base.establish_connection!(
  access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
)

S3_BUCKET = ENV['AWS_S3_BUCKET']
