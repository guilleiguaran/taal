module SimpleBuilder
  class App < Nancy::Base
    use Rack::Logger
    use Rack::PostBodyContentTypeParser
    use Rack::NestedParams

    get "/" do
      { info: "SimpleBuilder #{SimpleBuilder::VERSION}" }.to_json
    end

    get "/builds" do
      builds = Build.all
      builds.to_json
    end

    post "/builds" do
      build = Build.new(params["build"])
      if build.save
        QC.enqueue("SimpleBuilder::BuildJob.run", build.id)
        halt 201, build.to_json
      else
        halt 400, { error: "bad request" }.to_json
      end
    end

    get "/builds/:id" do
      build = Build[params["id"]]
      if build
        build.to_json
      else
        halt 404, { error: "not found" }.to_json
      end
    end
  end
end
