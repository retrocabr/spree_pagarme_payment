# coding: utf-8
require 'pagarme'

module Spree
  class BankAccount < Spree::Base
    default_scope { where(deleted_at: nil).order('created_at ASC') }

    belongs_to :user
    belongs_to :bank
    belongs_to :pagarme_recipients

    after_update :update_bank, :update_pagarme_bank_account
    after_create :update_bank, :get_bank_account

    scope :valid, -> { where.not(pagarme_id: nil) }
    scope :invalid, -> { where(pagarme_id: nil) }

    def destroy
      self.update_attributes(deleted_at: DateTime.current)
    end

    def delete
      destroy
    end

    def deleted?
      self.deleted_at.present?
    end

    def to_s
      [banco, agencia, conta, (cpf ? cpf : cnpj), nome, obs].join(" / ")
    end

    def bank_code
      if bank
        bank.code
      end
    end

    def complete?
      return false if bank.nil?
      return false if agencia.nil? or agencia == ""
      return false if conta.nil? or conta == ""
      return false if (cpf.nil? or cpf == "") and (cnpj.nil? or cnpj == "")
      return false if nome.nil? or nome == ""
      return true
    end

    def valid?
      !pagarme_id.nil?
    end

    def is_default?
      id == 2
    end

    def get_bank_account
      PagarMe.api_key = ENV['PAGARME_API_KEY']
      if self.pagarme_id
        PagarMe::BankAccount.find(self.pagarme_id)
      else
        if complete?
          _agencia = agencia.split('-')
          _conta = conta.split('-')
          _banco = bank.code
          _doc_type = cpf ? "cpf" : "cnpj"
          _doc_number = cpf ? cpf : cnpj

          pagarme_bank_account = PagarMe::BankAccount.create({
            :bank_code => _banco,
            :agencia => _agencia[0],
            :agencia_dv => _agencia[1],
            :conta => _conta[0],
            :conta_dv => _conta[1],
            :legal_name => nome,
            :document_type => _doc_type,
            :document_number => _doc_number,
            :charge_transfer_fees => charge_transfer_fees? ? true : false
          })

          self.update_column(:pagarme_id, pagarme_bank_account.id)
          pagarme_bank_account
        end
      end
    end

    private

    def update_bank
      b = Spree::Bank.where("name LIKE ?", "%#{self.banco}%").first
      if b
        self.update_column(:bank_id, b.id)
      else
        self.update_column(:bank_id, nil)
      end
    end

    def update_pagarme_bank_account
      # Cant simply update bank_account, must create a new one
      self.update_column(:pagarme_id, nil)
      get_bank_account
    end

  end
end
