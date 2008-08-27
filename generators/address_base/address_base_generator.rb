class AddressBaseGenerator < Rails::Generator::Base # must use 'Named' in order to pass params
  def manifest
    record do |m|
      # model
      m.file "address.rb", "app/models/address.rb"
      m.file "country.rb", "app/models/country.rb"
      m.file "state.rb", "app/models/state.rb"
      # controller
      m.file "addresses_controller.rb", "app/controllers/addresses_controller.rb"
      # directory
      m.directory('app/views/addresses')
      m.directory('db/migrate')
      # migration
      m.file "create_addresses.rb", "db/migrate/#{Time.now.year.to_s}#{(Time.now.to_i).to_s}_addresses.rb"
      m.file "create_country.rb",   "db/migrate/#{Time.now.year.to_s}#{(Time.now.to_i+1).to_s}_country.rb"
      m.file "create_state.rb",     "db/migrate/#{Time.now.year.to_s}#{(Time.now.to_i+2).to_s}_state.rb"
      # yml data
      m.file "countries.yml",  "test/fixtures/countries.yml"
      m.file "states.yml",     "test/fixtures/states.yml"
      
      # views
      m.file "application.rhtml", "app/views/layouts/application.rhtml"

      m.file "addresses/new.html.erb", "app/views/addresses/new.html.erb"
      m.file "addresses/edit.html.erb", "app/views/addresses/edit.html.erb"
      m.file "addresses/index.html.erb", "app/views/addresses/index.html.erb"
      m.file "addresses/show.html.erb", "app/views/addresses/show.html.erb"

      m.file "addresses/_edit.html.erb", "app/views/addresses/_edit.html.erb"
      m.file "addresses/_form.html.erb", "app/views/addresses/_form.html.erb"
      m.file "addresses/_show.html.erb", "app/views/addresses/_show.html.erb"
      m.file "addresses/_states.html.erb", "app/views/addresses/_states.html.erb"

      m.file "addresses/get_states.js.rjs", "app/views/addresses/get_states.js.rjs"

      # routes
      m.route_resources :addresses
    end
  end
end