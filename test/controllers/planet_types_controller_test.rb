require 'test_helper'

class PlanetTypesControllerTest < ActionController::TestCase
  setup do
    @planet_type = planet_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:planet_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create planet_type" do
    assert_difference('PlanetType.count') do
      post :create, planet_type: { name: @planet_type.name }
    end

    assert_redirected_to planet_type_path(assigns(:planet_type))
  end

  test "should show planet_type" do
    get :show, id: @planet_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @planet_type
    assert_response :success
  end

  test "should update planet_type" do
    patch :update, id: @planet_type, planet_type: { name: @planet_type.name }
    assert_redirected_to planet_type_path(assigns(:planet_type))
  end

  test "should destroy planet_type" do
    assert_difference('PlanetType.count', -1) do
      delete :destroy, id: @planet_type
    end

    assert_redirected_to planet_types_path
  end
end
