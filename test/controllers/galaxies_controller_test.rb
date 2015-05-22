require 'test_helper'

class GalaxiesControllerTest < ActionController::TestCase
  setup do
    @galaxy = galaxies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:galaxies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create galaxy" do
    assert_difference('Galaxy.count') do
      post :create, galaxy: { last_turn_at: @galaxy.last_turn_at, name: @galaxy.name, turn_number: @galaxy.turn_number }
    end

    assert_redirected_to galaxy_path(assigns(:galaxy))
  end

  test "should show galaxy" do
    get :show, id: @galaxy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @galaxy
    assert_response :success
  end

  test "should update galaxy" do
    patch :update, id: @galaxy, galaxy: { last_turn_at: @galaxy.last_turn_at, name: @galaxy.name, turn_number: @galaxy.turn_number }
    assert_redirected_to galaxy_path(assigns(:galaxy))
  end

  test "should destroy galaxy" do
    assert_difference('Galaxy.count', -1) do
      delete :destroy, id: @galaxy
    end

    assert_redirected_to galaxies_path
  end
end
