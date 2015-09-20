require File.dirname(__FILE__) + '/../test_helper'
require 'game_lines_controller'

# Re-raise errors caught by the controller.
class GameLinesController; def rescue_action(e) raise e end; end

class GameLinesControllerTest < Test::Unit::TestCase
  fixtures :game_lines

  def setup
    @controller = GameLinesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = game_lines(:first).id
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

    assert_not_nil assigns(:game_lines)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:game_line)
    assert assigns(:game_line).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:game_line)
  end

  def test_create
    num_game_lines = GameLine.count

    post :create, :game_line => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_game_lines + 1, GameLine.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:game_line)
    assert assigns(:game_line).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      GameLine.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      GameLine.find(@first_id)
    }
  end
end
