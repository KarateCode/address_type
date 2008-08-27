class AddressTypeGenerator < Rails::Generator::NamedBase # must use 'Named' in order to pass params
  def manifest
    record do |m|
      m.template "address.rb", "app/models/#{file_name}.rb"
      
      m.route_resources((file_name + '_addresses').to_sym)
    end
  end
end