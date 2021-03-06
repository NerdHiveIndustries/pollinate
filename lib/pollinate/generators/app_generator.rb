require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Pollinate
  class Generator < Rails::Generators::AppGenerator
    # let's use postgres by default
    class_option :database,       :type => :string, :aliases => "-d", :default => "postgresql",
                                  :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"
    # no Test::Unit by default
    class_option :skip_test_unit, :type => :boolean, :aliases => "-T", :default => true,
                                  :desc => "Skip Test::Unit files"

    class_option :heroku, :type => :boolean, :aliases => "-H", :default => false,
                          :desc => "Create staging and production heroku apps"

    def finish_template
      invoke :pollinate_customization
      super
    end

    def pollinate_customization
      invoke :remove_files_we_dont_need
      invoke :setup_development_environment
      invoke :setup_staging_environment
      invoke :create_pollinate_views
      invoke :customize_gemfile
      invoke :setup_database
      invoke :configure_app
      invoke :migrate_database
      invoke :copy_miscellaneous_files
      invoke :setup_root_route
      invoke :set_active_record_whitelist_attributes
      invoke :setup_git
      invoke :create_heroku_apps
      invoke :outro
    end

    def setup_root_route
      say "Setting up a root route"
      build(:setup_root_route)
    end

    def remove_files_we_dont_need
      build(:remove_public_index)
      build(:remove_public_images_rails)
    end

    def setup_development_environment
      say "Setting up the development environment"
      build(:raise_delivery_errors)
    end

    def setup_staging_environment
      say "Setting up the staging environment"
      build(:setup_staging_environment)
    end

    def create_pollinate_views
      say "Creating pollinate views"
      build(:create_application_layout)
    end

    def setup_database
      say "Setting up database"
      if 'postgresql' == options[:database]
        build(:use_postgres_config_template)
      end
      build(:create_database)
    end

    def migrate_database
      say "Migrating database"
      build(:migrate_database)
    end

    def configure_app
      say "Configuring app"
      build(:configure_rspec)
      build(:configure_action_mailer)
      build(:configure_default_includes)
      build(:install_rspec)
      build(:install_cucumber)
      build(:install_bootstrap)
      build(:install_formtastic)
      build(:install_devise)
      build(:install_factory_girl_steps)
      build(:add_email_validator)
      build(:setup_default_rake_task)
      build(:install_ember)
    end

    def customize_gemfile
      build(:include_custom_gems)
      build(:add_bootstrap_gem)
      build(:add_devise_gem)
      build(:create_bundler_config)
      build(:configure_gemset)
      build(:bundle_install)
    end

    def setup_git
      say "Initializing git and performing initial commit"
      build(:gitignore_files)
      build(:init_git)
    end

    def create_heroku_apps
      if options['heroku']
        say "Creating heroku apps"
        build(:create_heroku_apps)
        build(:document_heroku)
      end
    end

    def copy_miscellaneous_files
      say "Copying miscellaneous support files"
      build(:copy_miscellaneous_files)
    end

    def set_active_record_whitelist_attributes
      if using_active_record?
        say "Setting up active_record.whitelist_attributes"
        build(:set_active_record_whitelist_attributes)
      end
    end

    def outro
      say "Congratulations! You just pollinated a new site."
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end

    protected

    def get_builder_class
      Pollinate::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
