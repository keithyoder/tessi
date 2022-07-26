# frozen_string_literal: true

require 'application_system_test_case'

class ServidoresTest < ApplicationSystemTestCase
  setup do
    @servidor = servidores(:one)
  end

  test 'visiting the index' do
    visit servidores_url
    assert_selector 'h1', text: 'Servidores'
  end

  test 'creating a Servidor' do
    visit servidores_url
    click_on 'New Servidor'

    fill_in 'Api porta', with: @servidor.api_porta
    fill_in 'Ip', with: @servidor.ip
    fill_in 'Nome', with: @servidor.nome
    fill_in 'Senha', with: @servidor.senha
    fill_in 'Snmp comunidade', with: @servidor.snmp_comunidade
    fill_in 'Snmp porta', with: @servidor.snmp_porta
    fill_in 'Ssh porta', with: @servidor.ssh_porta
    fill_in 'Usuario', with: @servidor.usuario
    click_on 'Create Servidor'

    assert_text 'Servidor was successfully created'
    click_on 'Back'
  end

  test 'updating a Servidor' do
    visit servidores_url
    click_on 'Edit', match: :first

    fill_in 'Api porta', with: @servidor.api_porta
    fill_in 'Ip', with: @servidor.ip
    fill_in 'Nome', with: @servidor.nome
    fill_in 'Senha', with: @servidor.senha
    fill_in 'Snmp comunidade', with: @servidor.snmp_comunidade
    fill_in 'Snmp porta', with: @servidor.snmp_porta
    fill_in 'Ssh porta', with: @servidor.ssh_porta
    fill_in 'Usuario', with: @servidor.usuario
    click_on 'Update Servidor'

    assert_text 'Servidor was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Servidor' do
    visit servidores_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Servidor was successfully destroyed'
  end
end
