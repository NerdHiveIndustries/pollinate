module Pollinate
  class AppBuilder < Rails::AppBuilder
    include Pollinate::Actions

    def readme
      copy_file "README.md"
    end

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_public_images_rails
      remove_file 'app/assets/images/rails.png'
    end

    def configure_gemset
      gemset_script = <<-RUBY
      #!/usr/bin/env bash
      if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
        source "$HOME/.rvm/scripts/rvm"
      elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
        source "/usr/local/rvm/scripts/rvm"
      fi
      izafunction=`type rvm | head -n 1`
      if [ "$izafunction" == 'rvm is a function' ]; then
        name="#{app_name}"
        ruby_version=`rvm-prompt v p`
        rvm --create --rvmrc use $ruby_version@$name
        rvm rvmrc trust
      fi
      RUBY
      File.open("create_gemset.sh", "w+") {|file| file.write("#{gemset_script}") }
      system("bash create_gemset.sh")
      File.delete("create_gemset.sh")
    end

    def raise_delivery_errors
      replace_in_file "config/environments/development.rb", "raise_delivery_errors = false", "raise_delivery_errors = true"
    end

    def setup_staging_environment
      run "cp config/environments/production.rb config/environments/staging.rb"
    end

    def create_application_layout
      remove_file 'app/views/layouts/application.html.erb'
      directory "layouts", "app/views/layouts",
               :force => true
    end

    def create_bundler_config
      directory ".bundle", ".bundle"
    end

    def use_postgres_config_template
      template "postgresql_database.yml.erb", "config/database.yml", :force => true
    end

    def create_database
      bundle_exec('exec rake db:create')
    end

    def migrate_database
      bundle_exec('exec rake db:migrate')
    end

    def include_custom_gems
      additions_path = find_in_source_paths 'Gemfile_additions'
      new_gems = File.open(additions_path).read
      inject_into_file("Gemfile", "\n#{new_gems}", :after => /gem 'jquery-rails'/)
    end

    def add_bootstrap_gem
      inject_into_file("Gemfile", "\ngem 'less-rails'\ngem 'twitter-bootstrap-rails'", :after => /group :assets do/)
    end

    def add_devise_gem
      inject_into_file("Gemfile", "\ngem 'devise'", :after => /gem 'jquery-rails'/)
    end

    def configure_default_includes
      replace_in_file "app/assets/stylesheets/application.css", "*= require_tree .\n", ''
      replace_in_file "app/assets/javascripts/application.js", "//= require_tree .\n", ''
    end

    def configure_rspec
      generators_config = <<-RUBY
          config.generators do |generate|
            generate.test_framework :rspec
          end
      RUBY
      inject_into_class "config/application.rb", "Application", generators_config
    end

    def configure_action_mailer
      action_mailer_host "development", "#{app_name}.local"
      action_mailer_host "test",        "example.com"
      action_mailer_host "staging",     "staging.#{app_name}.com"
      action_mailer_host "production",  "#{app_name}.com"
    end

    def install_rspec
      generate "rspec:install"
      replace_in_file "spec/spec_helper.rb", "# config.mock_with :mocha", "config.mock_with :mocha"
    end

    def install_ember
      generate "ember:bootstrap -g"
      inject_into_file("config/application.rb", "config.ember.variant = :development", :after => "config.assets.version = '1.0'\n")
    end

    def install_tabulous
      generate "tabs"
      inject_into_file("app/tabs/tabulous.rb", "config.active_tab_clickable = true", :after => "# config.css.inactive_text_color = '#888'\n")
      inject_into_file("app/tabs/tabulous.rb", "config.bootstrap_style_subtabs = true", :after => "# config.css.inactive_text_color = '#888'\n")
      inject_into_file("app/tabs/tabulous.rb", "config.tabs_ul_class = \"nav nav-pills\"", :after => "# config.css.inactive_text_color = '#888'\n")
      inject_into_file("app/tabs/tabulous.rb", "config.css.scaffolding = false", :after => "# config.css.inactive_text_color = '#888'\n")
    end

    def install_cucumber
      generate "cucumber:install", "--rspec", "--capybara"
      inject_into_file "features/support/env.rb",
                       %{Capybara.save_and_open_page_path = 'tmp'\n} +
                       %{Capybara.javascript_driver = :webkit\n},
                       :before => %{Capybara.default_selector = :css}
    end

    def install_factory_girl_steps
      copy_file "factory_girl_steps.rb", "features/step_definitions/factory_girl_steps.rb"
    end

    def gitignore_files
      concat_file "pollinate_gitignore", ".gitignore"
      ["app/models",
        "app/views/pages",
        "db/migrate",
        "log",
        "tmp/pids",
        "tmp/sessions",
        "tmp/sockets",
        "spec/support",
        "spec/lib",
        "spec/models",
        "spec/controllers",
        "spec/support/matchers",
        "spec/support/mixins",
        "spec/support/shared_examples"].each do |dir|
        empty_directory_with_gitkeep dir
      end
    end

    def init_git
      run "git init"
      run "git add -A ."
      run "git commit -m 'Initial commit - pollinated project'"
    end

    def create_heroku_apps
      path_additions = ''
      if ENV['TESTING']
        support_bin = File.expand_path(File.join('..', '..', '..', 'features', 'support', 'bin'))
        path_addition = "PATH=#{support_bin}:$PATH"
      end
      run "#{path_addition} heroku create #{app_name}-production --remote=production --stack=cedar"
      run "#{path_addition} heroku create #{app_name}-staging    --remote=staging    --stack=cedar"
    end

    def document_heroku
      heroku_readme_path = find_in_source_paths 'HEROKU_README.md'
      documentation = File.open(heroku_readme_path).read
      inject_into_file("README.md", "#{documentation}\n", :before => "Most importantly")
    end

    def copy_miscellaneous_files
      copy_file "errors.rb", "config/initializers/errors.rb"
      copy_file "time_formats.rb", "config/initializers/time_formats.rb"
      copy_file "Procfile"
      copy_file "Capfile", "Capfile"
      copy_file "Guardfile", "Guardfile"
      copy_file ".rspec", ".rspec", :force => true
      copy_file "deploy.rb", "config/deploy.rb"
    end

    def set_active_record_whitelist_attributes
      inject_into_class "config/application.rb", "Application", "    config.active_record.whitelist_attributes = true\n"
    end

    def add_email_validator
      copy_file "email_validator.rb", "app/validators/email_validator.rb"
    end

    def setup_default_rake_task
      append_file "Rakefile" do
        "task(:default).clear\ntask :default => [:spec, :cucumber]"
      end
    end

    def install_bootstrap
      generate "bootstrap:install less"
      inject_into_file("app/assets/stylesheets/application.css", "*= require bootstrap_and_overrides\n", :after => "*= require_self\n")
      inject_into_file("app/assets/javascripts/application.js", "//= require bootstrap.js.coffee\n", :after => "//= require twitter/bootstrap\n")
    end

    def install_formtastic
      generate "formtastic:install"
      inject_into_file("config/initializers/formtastic.rb", "Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder\n", :after => "# Formtastic::Helpers::FormHelper.builder = MyCustomBuilder\n")
      inject_into_file("app/assets/stylesheets/application.css", "*= require formtastic-bootstrap\n", :after => "*= require_self\n")
      inject_into_file("app/assets/stylesheets/application.css", "*= require bootstrap-datepicker\n", :after => "*= require_self\n")
      inject_into_file("app/assets/javascripts/application.js", "//= require bootstrap-datepicker/core\n", :after => "//= require twitter/bootstrap\n")
    end

    def install_devise
      generate "devise:install"
      generate "devise User"
      generate "devise:views"
      run "for i in `find app/views/devise -name '*.erb'` ; do html2haml -e $i ${i%erb}haml ; rm $i ; done"
      run "for i in `find app/views/devise -name '*.haml'` ; do haml2slim $i ${i%haml}slim ; rm $i ; done"
    end

    def setup_root_route
      copy_file "home_controller.rb", "app/controllers/home_controller.rb"
      directory "home", "app/views/home"
      route "root :to => 'home#index'"
    end

    def bundle_install
      bundle_exec('install')
    end

    # def set_attr_accessibles_on_user
    #   inject_into_file "app/models/user.rb",
    #     "  attr_accessible :email, :password\n",
    #     :after => /include Clearance::User\n/
    # end

    # def include_clearance_matchers
    #   create_file "spec/support/clearance.rb", "require 'clearance/testing'"
    # end
  end
end
