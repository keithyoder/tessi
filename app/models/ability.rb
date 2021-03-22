# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    return unless user.present?

    if user.role?
      can :read, :all
      can :suspenso, Conexao
      can :boletos, Contrato
      can :boleto, Fatura
      can :encerrar, Atendimento.por_responsavel(user).abertos
      can %i[create update], [Bairro, Logradouro, Conexao, Pessoa, Os, Atendimento, AtendimentoDetalhe]
      cannot :update, Os.fechadas
      can :create, [Excecao]
    end
    if user.admin?
      can :manage, :all
      cannot :destroy, Estado
      cannot :encerrar, Atendimento.fechados
    elsif user.tecnico_n1?
      can [:update], [FibraCaixa]
      can %i[create update], Conexao
    elsif user.tecnico_n2?
      can :update, [Cidade, Ponto, Servidor]
      can %i[create update], [FibraRede, FibraCaixa, IpRede, Conexao]
      can :destroy, Conexao
      can [:backup, :backups], Servidor
    elsif user.financeiro_n1?
      can %i[update liquidacao], Fatura
      can [:renovar], Contrato
    elsif user.financeiro_n2?
      can :update, Cidade
      can :destroy, Conexao
      can %i[update liquidacao estornar cancelar gerar_nf], Fatura
      can %i[create update], [Retorno, Contrato]
      can %i[renovar destroy], Contrato
      can :remessa, PagamentoPerfil
    end
  end
end
