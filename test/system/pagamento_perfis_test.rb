require "application_system_test_case"

class PagamentoPerfisTest < ApplicationSystemTestCase
  setup do
    @pagamento_perfil = pagamento_perfis(:one)
  end

  test "visiting the index" do
    visit pagamento_perfis_url
    assert_selector "h1", text: "Pagamento Perfis"
  end

  test "creating a Pagamento perfil" do
    visit pagamento_perfis_url
    click_on "New Pagamento Perfil"

    fill_in "Agencia", with: @pagamento_perfil.agencia
    fill_in "Carteira", with: @pagamento_perfil.carteira
    fill_in "Cedente", with: @pagamento_perfil.cedente
    fill_in "Conta", with: @pagamento_perfil.conta
    fill_in "Nome", with: @pagamento_perfil.nome
    fill_in "Tipo", with: @pagamento_perfil.tipo
    click_on "Create Pagamento perfil"

    assert_text "Pagamento perfil was successfully created"
    click_on "Back"
  end

  test "updating a Pagamento perfil" do
    visit pagamento_perfis_url
    click_on "Edit", match: :first

    fill_in "Agencia", with: @pagamento_perfil.agencia
    fill_in "Carteira", with: @pagamento_perfil.carteira
    fill_in "Cedente", with: @pagamento_perfil.cedente
    fill_in "Conta", with: @pagamento_perfil.conta
    fill_in "Nome", with: @pagamento_perfil.nome
    fill_in "Tipo", with: @pagamento_perfil.tipo
    click_on "Update Pagamento perfil"

    assert_text "Pagamento perfil was successfully updated"
    click_on "Back"
  end

  test "destroying a Pagamento perfil" do
    visit pagamento_perfis_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pagamento perfil was successfully destroyed"
  end
end
