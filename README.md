# Spree Pagarme Payment

Implementação do [Pagar.me](https://pagar.me/) Payment à plataforma do [Spree Commerce](https://spreecommerce.com/). Além do Gateway, também implementamos o pagamento com Split (configurável). Utilizamos a [GEM pagarme-ruby](https://github.com/pagarme/pagarme-ruby).

Componentes:

- [x] Gateway
- [x] Transações
- [ ] Cartões
- [ ] Planos
- [ ] Assinaturas
- [x] POSTbak
- [x] Recebíveis
- [x] Saldo
- [x] Operações de Saldo
- [x] Contas bancárias
- [x] Recebedores
- [ ] Antecipações
- [x] Regras do Split
- [x] Transferências
- [ ] Clientes
- [ ] Buscas avançadas
- [ ] Códigos postais
- [ ] Erros
- [ ] Análises antifraude
- [ ] Usuário

## Installation

Clone este repositório e adicione a seguinte linha ao seu Gemfile:

```ruby
gem 'spree_pagarme_payment', github: 'SEU_REPOSITORIO/spree_pagarme_payment',
```

Execute os comandos:

    $ bundle install
    $ rails g spree_pagarme_payment:install

Ou instale manualmente:

    $ gem install spree_pagarme_payment

## Usage

1. Adicione as seguintes variáveis de ambiente:

```ruby
# Admin emails to receive error payment messages
ENV['ADMIN_EMAILS'] = "spree@example.com,spree@google.com"

# Pagarme keys
ENV['PAGARME_API_KEY'] = "YOUR_API_KEY_HERE"
ENV['PAGARME_CRYPTKEY'] = "YOUR_ENCRYPTION_KEY_HERE"
```

2. Crie um novo Payment Method:

Nome     | Coluna       | Valor                                
-------- | ------------ | -------------------------------------
Nome     | `name`       | `"Pagar.me"`
Provedor | `type`       | `Spree::PaymentMethod::PagarmeMethod`
Mostrar  | `display_on` | `Ambos` ou `Front End`
Ativo    | `active`     | Sim (`true`)

Para este método de pagamento, a captura é sempre automática, sem levar em conta a sua configuração.

## Configurando o Split

Edite o Método de Pagamento `Pagar.me` (criado no passo 2) após ter salvado pelo menos uma vez depois de ter definido o Provedor, haverá o checkbox `AUTO SPLIT` - deixe-o checado para realizar o split automático (segundo as regras de split dos produtos)

### Regras do Split

As regras do Split são definidas pelo `Spree::LineItem` (através do método `split_rule`). Personalize esse método de acordo com o seu modelo de negócio.

Quando o pedido é completado, são criadas `Spree::PagarmeSplitRule`s e `Spree::PagarmeSplitError` (mencionado na seção a seguir) para registrar as regras de Split aplicados no pagamento daquele pedido.

#### Split e StoreCredit?

Se a sua aplicação não utiliza o `Spree::StoreCredit`, você não precisa se preocupar com isso.

Quando o comprador usa Store Credits para pagar o pedido, seja parcialmente ou totalmente, às vezes não há valor o suficiente para um dos Recebedores. Quando isso ocorre, é criado um `Spree::PagarmeSplitError` com o valor que faltou para o Recebedor. Por exemplo:

```
Um pedido com 3 produtos e considerando que o split_rule repassa é 100% do preço do produto para o recebedor:

Produto  | Preço    | Recebedor ID
-------- | -------- | ------------
Camiseta | R$ 10.00 | 1
Calça    | R$ 30,00 | 2
Sapato   | R$ 60,00 | 3

Consideremos que o comprador utilizou seus créditos, no valor de R$70,00, para pagar parte do seu pedido. O valor pago pelo Pagar.me então é de R$30,00. Usando a ordem padrão (line_item_id), o split fica assim:

Recebedor  | A receber | Valor do Split | Valor que falta
---------- | --------- | -------------- | ---------------
1          | R$ 10.00  | R$ 10,00       | R$ 0,00        
2          | R$ 40,00  | R$ 20,00       | R$ 10,00       
3          | R$ 60,00  | R$ 0,00        | R$ 60,00       

No final então são criadas as instâncias do Spree::PagarmeSplitRule (valores iguais são criados no Spree::PagarmeBalance):

Recebedor  | Valor    
---------- | ---------
1          | R$ 10,00 
2          | R$ 20,00 

E as do Spree::PagarmeSplitError:

Recebedor  | Valor    
---------- | ---------
2          | R$ 10,00 
3          | R$ 60,00 
```

O que será feito com o valor que faltou para cada Recebedor fica a seu critério. Basta alterar o método `split_fallback` no modelo do `Spree::PagarmeSplitError`. E para priorizar os produtos a serem pagos, modifique o método `prioritize_for_split` no modelo do `Spree::LineItem`.

## Transferências



## Contributing

1. Fork it ( https://github.com/retrocabr/spree_pagarme_payment/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
