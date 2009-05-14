require "#{File.dirname(__FILE__)}/../test_helper"
require "ruby-debug"
Debugger.start

require 'booths_controller'

# Re-raise errors caught by the controller.
class BoothsController; def rescue_action(e) raise e end; end

class BoothsControllerTest < Test::Unit::TestCase
  #fixtures :all

	# ---------------------------------------------------------------------------
  def setup
    @controller = BoothsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
	
	# ---------------------------------------------------------------------------
  def test_get_index
		get :index
    assert_response :success
		assert_template "index"
		
		# Make sure the correct number of items were found
		assert_not_nil assigns(:featured_items)
		assert_not_nil assigns(:featured_booths)
		assert_not_nil assigns(:featured_user)
  end
	
	# ---------------------------------------------------------------------------
	def test_get_show
	end
  
	# ---------------------------------------------------------------------------
	def test_dont_show_non_committed
	end
	
	# ---------------------------------------------------------------------------
	def test_new_booth
	end
	
	# ---------------------------------------------------------------------------
	def test_booth_intro
=begin
		user = users('users_without_booth')
		assert_equal 0, Booth.find(:all, :conditions => { :seller_id => user.id }).size
		@request.session[:user_id] = user.id
		
		get :new
		assert_response :success
		assert_template "intro"
		
		@controller = BoothsController.new # this'll refresh the current_user's booth, and is consistent with the flow of a real subsequent request		
		booth = Booth.find(:all, :conditions => { :seller_id => user.id }) 
		assert_equal 1,booth.size # there should be one nad only one booth for this user
	
		booth = booth.first
		post :set_initial_defaults, :id => booth.id, :booth_intro => { :default_options_like => 'craigslist' }
		assert_response :redirect
		assert_redirected_to :controller => 'booths', :action => :edit, :id => booth.id
		# TODO: Make sure the right options were set
=end
	end
	
	# ---------------------------------------------------------------------------
	def test_edit_booth
	end
	
	# ---------------------------------------------------------------------------
	def test_booth_activate
	end

	# ---------------------------------------------------------------------------
	def test_booth_preview
	end
	
	private
	
	# ---------------------------------------------------------------------------
		
end
