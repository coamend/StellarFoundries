require 'test_helper'

class QuadrantsControllerTest < ActionController::TestCase
  setup do
    @quadrant = quadrants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quadrants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quadrant" do
    assert_difference('Quadrant.count') do
      post :create, quadrant: { name: @quadrant.name, quadrant_x: @quadrant.quadrant_x, quadrant_y: @quadrant.quadrant_y, universe_id: @quadrant.universe_id }
    end

    assert_redirected_to quadrant_path(assigns(:quadrant))
  end

  test "should show quadrant" do
    get :show, id: @quadrant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quadrant
    assert_response :success
  end

  test "should update quadrant" do
    patch :update, id: @quadrant, quadrant: { name: @quadrant.name, quadrant_x: @quadrant.quadrant_x, quadrant_y: @quadrant.quadrant_y, universe_id: @quadrant.universe_id }
    assert_redirected_to quadrant_path(assigns(:quadrant))
  end

  test "should destroy quadrant" do
    assert_difference('Quadrant.count', -1) do
      delete :destroy, id: @quadrant
    end

    assert_redirected_to quadrants_path
  end
end
