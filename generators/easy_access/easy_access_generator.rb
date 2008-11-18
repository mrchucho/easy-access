class EasyAccessGenerator < Rails::Generator::NamedBase
  default_options :skip_migration => false

  attr_reader :namespace, :module_prefix, :association

  def initialize(runtime_args, runtime_options = {})
    super
    @namespace = (args.shift || '')
    @module_prefix = @namespace.blank? ? '' : "#{@namespace}::"
    @association = class_name.downcase.pluralize
  end

  def manifest
    recorded_session = record do |m|
      m.class_collisions class_path, "#{class_name}"
      m.class_collisions [], "#{module_prefix}Exception", "#{module_prefix}AccessSystem"

      unless namespace.blank?
        m.directory File.join('lib', namespace.downcase)
      end
      m.directory File.join('app/models', class_path)

      m.template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      m.template 'access_system.rb', File.join("lib/#{namespace.downcase}", 'access_system.rb')
      m.template 'exception.rb', File.join("lib/#{namespace.downcase}", 'exception.rb')

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/,'')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//,'_').pluralize}"
      end
    end
    
    #
    # Post-install notes
    #
    action = File.basename($0) # grok the action from './script/generate' or whatever
    case action
    when "generate"
      puts "Ready to generate."
      puts ("-" * 80)
      puts "Once finished, don't forget to:"
      puts
      puts "- Include the AccessSystem module and #{class_name} association in your User model"
      puts "    class User < ActiveRecord::Base"
      puts "      include #{module_prefix}AccessSystem"
      puts "      has_and_belongs_to_many :#{association}"
      puts "      # ..."
      puts
      puts "- Customize the default access controls in #{module_prefix}AccessSytem::has_privilege_for?"
      puts
      puts ("-" * 80)
      puts
    when "destroy"
      puts
      puts ("-" * 80)
      puts
      puts "Don't forget to remove the AccessSystem module and #{class_name} association from app/models/user.rb"
      puts
      puts ("-" * 80)
      puts
    else
      puts "Didn't understand the action '#{action}' -- you might have missed the 'after running me' instructions."
    end
    recorded_session
  end

  protected

  def banner
    "Usage: #{$0} easy_access ModelName [ModuleNamespace]"
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-migration", "Don't generate a migration file for this model") { |v|
      options[:skip_migration] = true
    }
  end
end
