require "application_system_test_case"

class ConexoesTest < ApplicationSystemTestCase
  setup do
    @conexao = conexoes(:one)
  end

  test "visiting the index" do
    visit conexoes_url
    assert_selector "h1", text: "Conexoes"
  end

  test "creating a Conexao" do
    visit conexoes_url
    click_on "New Conexao"

    check "Auto bloqueio" if @conexao.auto_bloqueio
    check "Bloqueado" if @conexao.bloqueado
    fill_in "Ip", with: @conexao.ip
    fill_in "Pessoa", with: @conexao.pessoa_id
    fill_in "Plano", with: @conexao.plano_id
    fill_in "Ponto", with: @conexao.ponto_id
    fill_in "Velocidade", with: @conexao.velocidade
    click_on "Create Conexao"

    assert_text "Conexao was successfully created"
    click_on "Back"
  end

  test "updating a Conexao" do
    visit conexoes_url
    click_on "Edit", match: :first

    check "Auto bloqueio" if @conexao.auto_bloqueio
    check "Bloqueado" if @conexao.bloqueado
    fill_in "Ip", with: @conexao.ip
    fill_in "Pessoa", with: @conexao.pessoa_id
    fill_in "Plano", with: @conexao.plano_id
    fill_in "Ponto", with: @conexao.ponto_id
    fill_in "Velocidade", with: @conexao.velocidade
    click_on "Update Conexao"

    assert_text "Conexao was successfully updated"
    click_on "Back"
  end

  test "destroying a Conexao" do
    visit conexoes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Conexao was successfully destroyed"
  end
end
