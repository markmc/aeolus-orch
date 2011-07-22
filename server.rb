require 'yaml'
require 'sinatra'
require 'deltacloud'
require 'orch'

cfg = YAML::load(File.read("orch.cfg"))

raise "Missing API URL in orch.cfg" unless cfg[:api_url]

helpers do
  def deltacloud_client(api_url)
    auth = Rack::Auth::Basic::Request.new(request.env)
    (api_user, api_password) = auth.provided? && auth.basic? && auth.credentials ? auth.credentials : [ nil, nil ]
    DeltaCloud.new(api_user, api_password, api_url)
  end

  def ids_query(ids)
    '?' + URI.escape(ids.collect { |id| "id[]=#{id}" }.join("&"))
  end
end

get '/:ids', :provides => 'xml'  do |ids|
  q = ids_query(ids.split(','))

  client = deltacloud_client(cfg[:api_url])
  client.request(:get, client.entry_points[:instances] + q) do |response|
    response
  end
end

post '/', :provides => 'xml' do
  deployable = DeployableXML.new(request.body.read)
  deployable.validate!

  name = params[:name]
  realm = params[:realm]

  client = deltacloud_client(cfg[:api_url])

  ids = []
  deployable.assemblies.each do |assy|
    inst = client.create_instance(:name => name ? "#{name}:#{assy.name}" : assy.name,
                                  :image_id => assy.image_id,
                                  :hwp_id => assy.hwp,
                                  :realm_id => realm)
    ids << inst.id
  end

  q = ids_query(ids)

  client.request(:get, client.entry_points[:instances] + q) do |response|
    [201, { 'Location' => '/' + ids.join(',') }, response]
  end
end
