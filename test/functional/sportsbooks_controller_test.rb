require File.dirname(__FILE__) + '/../test_helper'
require 'sportsbooks_controller'

# Re-raise errors caught by the controller.
class SportsbooksController; def rescue_action(e) raise e end; end

class SportsbooksControllerTest < Test::Unit::TestCase
  fixtures :sportsbooks

  def setup
    @controller = SportsbooksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = sportsbooks(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:sportsbooks)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:sportsbook)
    assert assigns(:sportsbook).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:sportsbook)
  end

  def test_create
    num_sportsbooks = Sportsbook.count

    post :create, :sportsbook => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_sportsbooks + 1, Sportsbook.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:sportsbook)
    assert assigns(:sportsbook).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Sportsbook.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Sportsbook.find(@first_id)
    }
  end
end
