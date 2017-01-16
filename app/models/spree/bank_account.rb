# coding: utf-8
require 'pagarme'

module Spree
  class BankAccount < Spree::Base
    default_scope { order('created_at DESC') }

    belongs_to :user
    belongs_to :bank
    belongs_to :pagarme_recipients

    after_update :update_bank, :update_pagarme_bank_account
    after_create :update_bank, :get_bank_account

    MAIN_BANK_LIST = [
      'Banco Bradesco S.A. (237)',
      'Banco Citibank S.A. (745)',
      'Banco do Brasil S.A. (1)',
      'Banco Santander (Brasil) S.A. (33)',
      'Caixa Econômica Federal (104)',
      'HSBC Bank Brasil S.A. - Banco Múltiplo (399)',
      'Itaú Unibanco S.A. (341)',
      'Outro'
    ]

    BANK_LIST = [
      'Banco A.J. Renner S.A. (654)',
      'Banco ABC Brasil S.A. (246)',
      'Banco Alfa S.A. (25)',
      'Banco Alvorada S.A. (641)',
      'Banco Arbi S.A. (213)',
      'Banco Azteca do Brasil S.A. (19)',
      # 'Banco BANDEPE S.A. (24)',
      'Banco Banerj S.A. (29)',
      'Banco Bankpar S.A. (0)',
      'Banco Barclays S.A. (740)',
      'Banco BBM S.A. (107)',
      'Banco Beg S.A. (31)',
      'Banco BGN S.A. (739)',
      'Banco BM&F de Serviços de Liquidação e Custódia S.A (96)',
      'Banco BMG S.A. (318)',
      'Banco BNP Paribas Brasil S.A. (752)',
      'Banco Boavista Interatlântico S.A. (248)',
      'Banco Bonsucesso S.A. (218)',
      'Banco Bracce S.A. (65)',
      'Banco Bradesco BBI S.A. (36)',
      'Banco Bradesco Cartões S.A. (204)',
      'Banco Bradesco Financiamentos S.A. (394)',
      'Banco Bradesco S.A. (237)',
      'Banco Brascan S.A. (225)',
      'Banco BRJ S.A. (M15)',
      'Banco BTG Pactual S.A. (208)',
      'Banco BVA S.A. (44)',
      'Banco Cacique S.A. (263)',
      'Banco Caixa Geral - Brasil S.A. (473)',
      'Banco Capital S.A. (412)',
      'Banco Cargill S.A. (40)',
      # 'Banco Cetelem S.A. (739)',
      # 'Banco Cifra S.A. (233)',
      'Banco Citibank S.A. (745)',
      'Banco Citicard S.A. (M08)',
      'Banco Clássico S.A. (241)',
      'Banco CNH Capital S.A. (M19)',
      'Banco Comercial e de Investimento Sudameris S.A. (215)',
      # 'Banco Confidence de Câmbio S.A. (95)',
      'Banco Cooperativo do Brasil S.A. - BANCOOB (756)',
      'Banco Cooperativo Sicredi S.A. (748)',
      'Banco CR2 S.A. (75)',
      'Banco Credibel S.A. (721)',
      'Banco Credit Agricole Brasil S.A. (222)',
      'Banco Credit Suisse (Brasil) S.A. (505)',
      'Banco Credibel S.A. (229)',
      'Banco Cruzeiro do Sul S.A. (266)',
      'Banco da Amazônia S.A. (3)',
      'Banco da China Brasil S.A. (083-3)',
      'Banco Daimlerchrysler S.A. (M21)',
      'Banco Daycoval S.A. (707)',
      'Banco de La Nacion Argentina (300)',
      'Banco de La Provincia de Buenos Aires (495)',
      'Banco de La Republica Oriental del Uruguay (494)',
      'Banco de Lage Landen Brasil S.A. (M06)',
      'Banco de Pernambuco S.A. - BANDEPE (24)',
      'Banco de Tokyo-Mitsubishi UFJ Brasil S.A. (456)',
      'Banco Dibens S.A. (214)',
      'Banco do Brasil S.A. (1)',
      'Banco do Estado de Sergipe S.A. (47)',
      'Banco do Estado do Pará S.A. (37)',
      'Banco do Estado do Piauí S.A. (39)',
      'Banco do Estado do Rio Grande do Sul S.A. (41)',
      'Banco do Nordeste do Brasil S.A. (4)',
      'Banco Fator S.A. (265)',
      'Banco Fiat S.A. (M03)',
      'Banco Fibra S.A. (224)',
      'Banco Ficsa S.A. (626)',
      # 'Banco Finasa BMC S.A. (394)',
      'Banco Ford S.A. (M18)',
      'Banco GE Capital S.A. (233)',
      'Banco Gerdau S.A. (734)',
      'Banco GMAC S.A. (M07)',
      'Banco Guanabara S.A. (612)',
      'Banco Honda S.A. (M22)',
      'Banco Ibi S.A. Banco Múltiplo (63)',
      'Banco IBM S.A. (M11)',
      'Banco Industrial do Brasil S.A. (604)',
      'Banco Industrial e Comercial S.A. (320)',
      'Banco Indusval S.A. (653)',
      'Banco Intercap S.A. (630)',
      'Banco Intermedium S.A. (077-9)',
      'Banco Investcred Unibanco S.A. (249)',
      'Banco Itaucred Financiamentos S.A. (M09)',
      'Banco Itaú BBA S.A. (184)',
      'Banco ItaúBank S.A (479)',
      'Banco Itaucred Financiamentos S.A. (M09)',
      'Banco J. P. Morgan S.A. (376)',
      'Banco J. Safra S.A. (74)',
      'Banco John Deere S.A. (217)',
      'Banco KDB S.A. (76)',
      'Banco KEB do Brasil S.A. (757)',
      'Banco Luso Brasileiro S.A. (600)',
      'Banco Matone S.A. (212)',
      'Banco Maxinvest S.A. (M12)',
      'Banco Mercantil do Brasil S.A. (389)',
      # 'Banco Mizuho do Brasil S.A. (370)',
      'Banco Modal S.A. (746)',
      'Banco Moneo S.A. (M10)',
      'Banco Morada S.A. (738)',
      'Banco Morgan Stanley S.A. (66)',
      'Banco Máxima S.A. (243)',
      'Banco Opportunity S.A. (45)',
      'Banco Ourinvest S.A. (M17)',
      # 'Banco Original S.A. (212)',
      'Banco Panamericano S.A. (623)',
      'Banco Paulista S.A. (611)',
      'Banco Pecúnia S.A. (613)',
      'Banco Petra S.A. (094-2)',
      'Banco Pine S.A. (643)',
      'Banco Porto Seguro S.A. (724)',
      'Banco Pottencial S.A. (735)',
      'Banco Prosper S.A. (638)',
      'Banco PSA Finance Brasil S.A. (M24)',
      'Banco Rabobank International Brasil S.A. (747)',
      'Banco Randon S.A. (088-4)',
      'Banco Real S.A. (356)',
      'Banco Rendimento S.A. (633)',
      'Banco Ribeirão Preto S.A. (741)',
      'Banco Rodobens S.A. (M16)',
      'Banco Rural Mais S.A. (72)',
      'Banco Rural S.A. (453)',
      'Banco Safra S.A. (422)',
      'Banco Santander (Brasil) S.A. (33)',
      'Banco Schahin S.A. (250)',
      'Banco Semear S.A. (743)',
      'Banco Simples S.A. (749)',
      'Banco Société Générale Brasil S.A. (366)',
      'Banco Sofisa S.A. (637)',
      'Banco Standard de Investimentos S.A. (12)',
      'Banco Sumitomo Mitsui Brasileiro S.A. (464)',
      'Banco Topázio S.A. (082-5)',
      'Banco Toyota do Brasil S.A. (M20)',
      'Banco Tricury S.A. (M13)',
      'Banco Triângulo S.A. (634)',
      'Banco Volkswagen S.A. (M14)',
      'Banco Volvo (Brasil) S.A. (M23)',
      'Banco Votorantim S.A. (655)',
      'Banco VR S.A. (610)',
      'Banco WestLB do Brasil S.A. (370)',
      # 'Banco Western Union do Brasil S.A. (119)',
      'BANESTES S.A. Banco do Estado do Espírito Santo (21)',
      'Banif-Banco Internacional do Funchal (Brasil)S.A. (719)',
      'Bank of America Merrill Lynch Banco Múltiplo S.A. (755)',
      'BankBoston N.A. (744)',
      'BB Banco Popular do Brasil S.A. (73)',
      # 'BCV - Banco de Crédito e Varejo S.A. (250)',
      'BES Investimento do Brasil S.A.-Banco de Investimento (78)',
      'BPN Brasil Banco Múltiplo S.A. (69)',
      'BRB - Banco de Brasília S.A. (70)',
      'Brickell S.A. Crédito, Financiamento e Investimento (092-2)',
      'Caixa Econômica Federal (104)',
      'Citibank S.A. (477)',
      'Concórdia Banco S.A. (081-7)',
      'Cooperativa Central de Crédito Noroeste Brasileiro Ltda. (097-3)',
      'Cooperativa Central de Crédito Urbano-CECRED (085-x)',
      'Cooperativa Central de Economia e Credito Mutuo das Unicreds (099-x)',
      'Cooperativa Central de Economia e Crédito Mutuo das Unicreds (090-2)',
      'Cooperativa de Crédito Rural da Região de Mogiana (089-2)',
      'Cooperativa Unicred Central Santa Catarina (087-6)',
      'Credicorol Cooperativa de Crédito Rural (098-1)',
      'Deutsche Bank S.A. - Banco Alemão (487)',
      'Dresdner Bank Brasil S.A. - Banco Múltiplo (751)',
      'Goldman Sachs do Brasil Banco Múltiplo S.A. (64)',
      'Hipercard Banco Múltiplo S.A. (62)',
      'HSBC Bank Brasil S.A. - Banco Múltiplo (399)',
      'HSBC Finance (Brasil) S.A. (168)',
      'ING Bank N.V. (492)',
      'Itaú Unibanco Holding S.A. (652)',
      'Itaú Unibanco S.A. (341)',
      'JBS Banco S.A. (79)',
      'JPMorgan Chase Bank (488)',
      'Natixis Brasil S.A. Banco Múltiplo (14)',
      'NBC Bank Brasil S.A. (753)',
      'OBOE Crédito Financiamento e Investimento S.A. (086-8)',
      'Paraná Banco S.A. (254)',
      # 'Scotiabank Brasil S.A. Banco Múltiplo (751)',
      'UNIBANCO - União de Bancos Brasileiros S.A. (409)',
      'Unicard Banco Múltiplo S.A. (230)',
      'Unicred Central do Rio Grande do Sul (91-4)',
      'Unicred Norte do Paraná (84)'
    ]

    def to_s
      [banco, agencia, conta, (cpf ? cpf : cnpj), nome, obs].join(" / ")
    end

    def bank_code
      if bank
        bank.code
      end
    end

    def update_bank
      b = Spree::Bank.where("name LIKE ?", "%#{self.banco}%").first
      self.update_column(:bank_id, b.id) if b
    end

    def complete?
      return false if bank.nil?
      return false if agencia.nil? or agencia == ""
      return false if conta.nil? or conta == ""
      return false if (cpf.nil? or cpf == "") and (cnpj.nil? or cnpj == "")
      return false if nome.nil? or nome == ""
      return true
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

    def update_pagarme_bank_account
      # Cant simply update bank_account, must create a new one
      self.update_column(:pagarme_id, nil)
      get_bank_account
    end

  end
end
