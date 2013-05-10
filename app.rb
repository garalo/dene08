require 'rubygems'
require 'pakyow'
require 'pp'
require 'dm-migrations'
require 'data_mapper'
require 'dm-tags'
require 'dm-core'
require 'dm-validations'

module PakyowApplication
  class Application < Pakyow::Application
    #include Pakyow::Helpers

    def initialize(*args)
      super
      DataMapper.finalize
      DataMapper.auto_upgrade!
    end

    config.app.default_environment = :development

    configure(:development) do
      DataMapper.setup(:default, "sqlite://#{File.expand_path(File.dirname(__FILE__))}/development.db")
      # DataMapper.setup(:default, 'sqlite:///Users/ahmet/pakyoworks/dene08/test.sqlite')
      DataMapper::Logger.new("#{File.expand_path(File.dirname(__FILE__))}/dm.log", :debug)
      DataMapper::Model.raise_on_save_failure = true

      app.log = true
      app.dev_mode = true
      app.errors_in_browser = true
      app.static = false  # keep stylesheet. stylesheet bozulmamasi icin false yapiyoruz. yoksa /posts/stylesheets/style.css oluyor ve hatali oluyor

    end


    core do
       expand(:restful, :post, 'posts') {
        #action(:index) {
        #  # not listing the posts  why???
        #  #view.scope(:post).apply(Post.all)
        #}

        action(:default) {
          view.scope(:post).apply(Post.all)
        }

        action(:show) {
          # show a post for params[:id]
         #pp pr =  params[:id]
         pp pr =  Post.get(params[:id].to_i)
         view.scope(:post).bind(pr)

        }

        action(:new) {
          # render a new form
          view.scope(:post).bind(Post.new)
        }
        action(:create) {
          # create the new post
          post = Post.new(request.params['post'])
          puts params.inspect
          puts " post title -----> : #{post.title}"
          pp post.valid? # => true
          pp post.save

          puts("post is saved:"+post.saved?.to_s)
          post.errors.each do |e|
            puts e
          end

          app.redirect('/posts/')

        }
        action(:edit) {
          # setup the form for an existing post by binding the post to the form
        }
        action(:update) {
          # update the post
        }
      }

    end

    presenter do
      scope(:post) {
        restful(:post) # post references the group created when expanding the restful template

        binding(:show_link) {
          {
              content: bindable[:title],
              href: router.group(:posts).path(:show, bindable)
          }
        }
      }
    end

  end
end
