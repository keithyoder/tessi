require "application_system_test_case"

class FibraRedesTest < ApplicationSystemTestCase
  setup do
    @fibra_rede = fibra_redes(:one)
  end

  test "visiting the index" do
    visit fibra_redes_url
    assert_selector "h1", text: "Fibra Redes"
  end

  test "creating a Fibra rede" do
    visit fibra_redes_url
    click_on "New Fibra Rede"

    fill_in "Nome", with: @fibra_rede.nome
    fill_in "Ponto", with: @fibra_rede.ponto_id
    click_on "Create Fibra rede"

    assert_text "Fibra rede was successfully created"
    click_on "Back"
  end

  test "updating a Fibra rede" do
    visit fibra_redes_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @fibra_rede.nome
    fill_in "Ponto", with: @fibra_rede.ponto_id
    click_on "Update Fibra rede"

    assert_text "Fibra rede was successfully updated"
    click_on "Back"
  end

  test "destroying a Fibra rede" do
    visit fibra_redes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fibra rede was successfully destroyed"
  end
end
