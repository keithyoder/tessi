require "application_system_test_case"

class OsTest < ApplicationSystemTestCase
  setup do
    @os = os(:one)
  end

  test "visiting the index" do
    visit os_url
    assert_selector "h1", text: "Os"
  end

  test "creating a Os" do
    visit os_url
    click_on "New Os"

    fill_in "Aberto por", with: @os.aberto_por_id
    fill_in "Classificao", with: @os.classificao_id
    fill_in "Conexao", with: @os.conexao_id
    fill_in "Descricao", with: @os.descricao
    fill_in "Encerramento", with: @os.encerramento
    fill_in "Fechamento", with: @os.fechamento
    fill_in "Pessoa", with: @os.pessoa_id
    fill_in "Responsavel", with: @os.responsavel_id
    fill_in "Tecnico 1", with: @os.tecnico_1_id
    fill_in "Tecnico 2", with: @os.tecnico_2_id
    fill_in "Tipo", with: @os.tipo
    click_on "Create Os"

    assert_text "Os was successfully created"
    click_on "Back"
  end

  test "updating a Os" do
    visit os_url
    click_on "Edit", match: :first

    fill_in "Aberto por", with: @os.aberto_por_id
    fill_in "Classificao", with: @os.classificao_id
    fill_in "Conexao", with: @os.conexao_id
    fill_in "Descricao", with: @os.descricao
    fill_in "Encerramento", with: @os.encerramento
    fill_in "Fechamento", with: @os.fechamento
    fill_in "Pessoa", with: @os.pessoa_id
    fill_in "Responsavel", with: @os.responsavel_id
    fill_in "Tecnico 1", with: @os.tecnico_1_id
    fill_in "Tecnico 2", with: @os.tecnico_2_id
    fill_in "Tipo", with: @os.tipo
    click_on "Update Os"

    assert_text "Os was successfully updated"
    click_on "Back"
  end

  test "destroying a Os" do
    visit os_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Os was successfully destroyed"
  end
end
