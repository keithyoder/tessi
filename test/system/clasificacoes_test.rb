require "application_system_test_case"

class ClasificacoesTest < ApplicationSystemTestCase
  setup do
    @clasificacao = clasificacoes(:one)
  end

  test "visiting the index" do
    visit clasificacoes_url
    assert_selector "h1", text: "Clasificacoes"
  end

  test "creating a Clasificacao" do
    visit clasificacoes_url
    click_on "New Clasificacao"

    fill_in "Nome", with: @clasificacao.nome
    fill_in "Tipo", with: @clasificacao.tipo
    click_on "Create Clasificacao"

    assert_text "Clasificacao was successfully created"
    click_on "Back"
  end

  test "updating a Clasificacao" do
    visit clasificacoes_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @clasificacao.nome
    fill_in "Tipo", with: @clasificacao.tipo
    click_on "Update Clasificacao"

    assert_text "Clasificacao was successfully updated"
    click_on "Back"
  end

  test "destroying a Clasificacao" do
    visit clasificacoes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Clasificacao was successfully destroyed"
  end
end
