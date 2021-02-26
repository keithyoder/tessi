require "application_system_test_case"

class AtendimentoDetalhesTest < ApplicationSystemTestCase
  setup do
    @atendimento_detalhe = atendimento_detalhes(:one)
  end

  test "visiting the index" do
    visit atendimento_detalhes_url
    assert_selector "h1", text: "Atendimento Detalhes"
  end

  test "creating a Atendimento detalhe" do
    visit atendimento_detalhes_url
    click_on "New Atendimento Detalhe"

    fill_in "Atendente", with: @atendimento_detalhe.atendente_id
    fill_in "Atendimento", with: @atendimento_detalhe.atendimento_id
    fill_in "Descricao", with: @atendimento_detalhe.descricao
    fill_in "Tipo", with: @atendimento_detalhe.tipo
    click_on "Create Atendimento detalhe"

    assert_text "Atendimento detalhe was successfully created"
    click_on "Back"
  end

  test "updating a Atendimento detalhe" do
    visit atendimento_detalhes_url
    click_on "Edit", match: :first

    fill_in "Atendente", with: @atendimento_detalhe.atendente_id
    fill_in "Atendimento", with: @atendimento_detalhe.atendimento_id
    fill_in "Descricao", with: @atendimento_detalhe.descricao
    fill_in "Tipo", with: @atendimento_detalhe.tipo
    click_on "Update Atendimento detalhe"

    assert_text "Atendimento detalhe was successfully updated"
    click_on "Back"
  end

  test "destroying a Atendimento detalhe" do
    visit atendimento_detalhes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Atendimento detalhe was successfully destroyed"
  end
end
