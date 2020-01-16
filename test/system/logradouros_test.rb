require "application_system_test_case"

class LogradourosTest < ApplicationSystemTestCase
  setup do
    @logradouro = logradouros(:one)
  end

  test "visiting the index" do
    visit logradouros_url
    assert_selector "h1", text: "Logradouros"
  end

  test "creating a Logradouro" do
    visit logradouros_url
    click_on "New Logradouro"

    fill_in "Bairro", with: @logradouro.bairro_id
    fill_in "Cep", with: @logradouro.cep
    fill_in "Nome", with: @logradouro.nome
    click_on "Create Logradouro"

    assert_text "Logradouro was successfully created"
    click_on "Back"
  end

  test "updating a Logradouro" do
    visit logradouros_url
    click_on "Edit", match: :first

    fill_in "Bairro", with: @logradouro.bairro_id
    fill_in "Cep", with: @logradouro.cep
    fill_in "Nome", with: @logradouro.nome
    click_on "Update Logradouro"

    assert_text "Logradouro was successfully updated"
    click_on "Back"
  end

  test "destroying a Logradouro" do
    visit logradouros_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Logradouro was successfully destroyed"
  end
end
