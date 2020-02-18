require "application_system_test_case"

class RetornosTest < ApplicationSystemTestCase
  setup do
    @retorno = retornos(:one)
  end

  test "visiting the index" do
    visit retornos_url
    assert_selector "h1", text: "Retornos"
  end

  test "creating a Retorno" do
    visit retornos_url
    click_on "New Retorno"

    fill_in "Data", with: @retorno.data
    fill_in "Date,", with: @retorno.date,
    fill_in "Integer", with: @retorno.integer
    fill_in "Pagamento perfil", with: @retorno.pagamento_perfil
    fill_in "Reference,", with: @retorno.reference,
    fill_in "Sequencia", with: @retorno.sequencia
    click_on "Create Retorno"

    assert_text "Retorno was successfully created"
    click_on "Back"
  end

  test "updating a Retorno" do
    visit retornos_url
    click_on "Edit", match: :first

    fill_in "Data", with: @retorno.data
    fill_in "Date,", with: @retorno.date,
    fill_in "Integer", with: @retorno.integer
    fill_in "Pagamento perfil", with: @retorno.pagamento_perfil
    fill_in "Reference,", with: @retorno.reference,
    fill_in "Sequencia", with: @retorno.sequencia
    click_on "Update Retorno"

    assert_text "Retorno was successfully updated"
    click_on "Back"
  end

  test "destroying a Retorno" do
    visit retornos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Retorno was successfully destroyed"
  end
end
