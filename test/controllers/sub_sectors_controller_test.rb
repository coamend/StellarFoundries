require 'test_helper'

class SubSectorsControllerTest < ActionController::TestCase
  setup do
    @sub_sector = sub_sectors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sub_sectors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sub_sector" do
    assert_difference('SubSector.count') do
      post :create, sub_sector: { sector_id: @sub_sector.sector_id, subsector_X: @sub_sector.subsector_X, subsector_Y: @sub_sector.subsector_Y }
    end

    assert_redirected_to sub_sector_path(assigns(:sub_sector))
  end

  test "should show sub_sector" do
    get :show, id: @sub_sector
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sub_sector
    assert_response :success
  end

  test "should update sub_sector" do
    patch :update, id: @sub_sector, sub_sector: { sector_id: @sub_sector.sector_id, subsector_X: @sub_sector.subsector_X, subsector_Y: @sub_sector.subsector_Y }
    assert_redirected_to sub_sector_path(assigns(:sub_sector))
  end

  test "should destroy sub_sector" do
    assert_difference('SubSector.count', -1) do
      delete :destroy, id: @sub_sector
    end

    assert_redirected_to sub_sectors_path
  end
end
