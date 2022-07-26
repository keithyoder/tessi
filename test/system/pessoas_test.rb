# frozen_string_literal: true

require 'application_system_test_case'

class PessoasTest < ApplicationSystemTestCase
  setup do
    @pessoa = pessoas(:one)
  end

  test 'visiting the index' do
    visit pessoas_url
    assert_selector 'h1', text: 'Pessoas'
  end

  test 'creating a Pessoa' do
    visit pessoas_url
    click_on 'New Pessoa'

    fill_in 'Cnpj', with: @pessoa.cnpj
    fill_in 'Complemento', with: @pessoa.complemento
    fill_in 'Cpf', with: @pessoa.cpf
    fill_in 'Email', with: @pessoa.email
    fill_in 'Ie', with: @pessoa.ie
    fill_in 'Logradouro', with: @pessoa.logradouro_id
    fill_in 'Nascimento', with: @pessoa.nascimento
    fill_in 'Nome', with: @pessoa.nome
    fill_in 'Nomemae', with: @pessoa.nomemae
    fill_in 'Numero', with: @pessoa.numero
    fill_in 'Rg', with: @pessoa.rg
    fill_in 'Telefone1', with: @pessoa.telefone1
    fill_in 'Telefone2', with: @pessoa.telefone2
    fill_in 'Tipo', with: @pessoa.tipo
    click_on 'Create Pessoa'

    assert_text 'Pessoa was successfully created'
    click_on 'Back'
  end

  test 'updating a Pessoa' do
    visit pessoas_url
    click_on 'Edit', match: :first

    fill_in 'Cnpj', with: @pessoa.cnpj
    fill_in 'Complemento', with: @pessoa.complemento
    fill_in 'Cpf', with: @pessoa.cpf
    fill_in 'Email', with: @pessoa.email
    fill_in 'Ie', with: @pessoa.ie
    fill_in 'Logradouro', with: @pessoa.logradouro_id
    fill_in 'Nascimento', with: @pessoa.nascimento
    fill_in 'Nome', with: @pessoa.nome
    fill_in 'Nomemae', with: @pessoa.nomemae
    fill_in 'Numero', with: @pessoa.numero
    fill_in 'Rg', with: @pessoa.rg
    fill_in 'Telefone1', with: @pessoa.telefone1
    fill_in 'Telefone2', with: @pessoa.telefone2
    fill_in 'Tipo', with: @pessoa.tipo
    click_on 'Update Pessoa'

    assert_text 'Pessoa was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Pessoa' do
    visit pessoas_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Pessoa was successfully destroyed'
  end
end
