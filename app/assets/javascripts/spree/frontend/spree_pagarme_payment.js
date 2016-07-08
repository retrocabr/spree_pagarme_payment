/*
--------------------------------------------------------
 Pagar.me Checkout (INTEGRAÇÃO VIA CHECKOUT)
--------------------------------------------------------

 Check out Pagar.me's documentation for more information
 and configuration instructions.

 This particular configuration only asks for customer's
 payment data (credit card/boleto), returning a card
 hash.

*/ 
var open_pagarme_payment_form = function(charge_amount){
  var encryption_key = $("#pagarme_script").data("crypt");
  var payment_methods = $("#pagarme_script").data("paymentmethods");

  $('#checkout').on( 'click' , '.btn.btn-success' , function(e){      
    checkout = new PagarMeCheckout.Checkout({
      "encryption_key":encryption_key,
      success: function(response){
        // console.log(response)
        $("#order_payments_attributes_0_pagarme_payment_attributes_card_hash").val(response.card_hash)
        $("#order_payments_attributes_0_pagarme_payment_attributes_payment_method").val(response.payment_method);
        if(response.payment_method == "credit_card"){
          $("#order_payments_attributes_0_pagarme_payment_attributes_installments").val(response.installments);
        }
        $("form#checkout_form_payment").submit()
      }
    });
    
    params = {
      "createToken": "false",
      "amount": charge_amount.toString(),
      "customerData": false,
      "paymentButtonText": "Finalizar pagamento", // 'Complete Payment' - text of the last button
      "maxInstallments": 12, // # max of installments allowed
      "interestRate": 2.49,  // % of interest Rate
      "freeInstallments": 3, // # of installments free of taxation
      "paymentMethods": payment_methods // array with up to two payment methods: 'credit_card' and/or 'boleto'.
                                        // This was made this way so we could make ruby check which options to show.
    }
    checkout.open(params)
  });
}

/*
  Uncomment the code below if you'd like to activate Pagar.me checkout on Checkout's Payment step.
  Although it was not tested if it really works. =(
*/
// $(document).ready(function(){
//   $("#checkout_form_payment").on("click",".btn", function(e){
//     e.preventDefault();
//     open_pagarme_payment_form(???); // Inform order total to charge
//   });
// });