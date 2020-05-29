require "application_system_test_case"

class Nf21sTest < ApplicationSystemTestCase
  setup do
    @nf21 = nf21s(:one)
  end

  test "visiting the index" do
    visit nf21s_url
    assert_selector "h1", text: "Nf21s"
  end

  test "creating a Nf21" do
    visit nf21s_url
    click_on "New Nf21"

    fill_in "Cadastro", with: @nf21.cadastro
    fill_in "Date,", with: @nf21.date,
    fill_in "Decimal,", with: @nf21.decimal,
    fill_in "Emissao", with: @nf21.emissao
    fill_in "Integer,", with: @nf21.integer,
    fill_in "Mestre", with: @nf21.mestre
    fill_in "Numero", with: @nf21.numero
    fill_in "Text", with: @nf21.text
    fill_in "Text,", with: @nf21.text,
    fill_in "Valor", with: @nf21.valor
    click_on "Create Nf21"

    assert_text "Nf21 was successfully created"
    click_on "Back"
  end

  test "updating a Nf21" do
    visit nf21s_url
    click_on "Edit", match: :first

    fill_in "Cadastro", with: @nf21.cadastro
    fill_in "Date,", with: @nf21.date,
    fill_in "Decimal,", with: @nf21.decimal,
    fill_in "Emissao", with: @nf21.emissao
    fill_in "Integer,", with: @nf21.integer,
    fill_in "Mestre", with: @nf21.mestre
    fill_in "Numero", with: @nf21.numero
    fill_in "Text", with: @nf21.text
    fill_in "Text,", with: @nf21.text,
    fill_in "Valor", with: @nf21.valor
    click_on "Update Nf21"

    assert_text "Nf21 was successfully updated"
    click_on "Back"
  end

  test "destroying a Nf21" do
    visit nf21s_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Nf21 was successfully destroyed"
  end
end
