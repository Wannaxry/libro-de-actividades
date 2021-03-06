require File.dirname(__FILE__) + '/../test_helper'
require 'cursos_controller'

# Re-raise errors caught by the controller.
class CursosController; def rescue_action(e) raise e end; end

class CursosControllerTest < Test::Unit::TestCase
  fixtures :cursos

  def setup
    @controller = CursosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = cursos(:first).id
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

    assert_not_nil assigns(:cursos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:curso)
    assert assigns(:curso).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:curso)
  end

  def test_create
    num_cursos = Curso.count

    post :create, :curso => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_cursos + 1, Curso.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:curso)
    assert assigns(:curso).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Curso.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Curso.find(@first_id)
    }
  end
end
