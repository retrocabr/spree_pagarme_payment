module Spree
  module Admin
    class BankAccountsController < Spree::Admin::BaseController
      respond_to :html, :js
      before_action :load_user

      # GET /admin/users/:user_id/bank_accounts
      # admin_user_bank_accounts_path
      def index
        @bank_accounts = @user.bank_accounts

        respond_to do |format|
          format.html # index.html.erb
        end
      end

      # GET /admin/users/:user_id/bank_accounts/new
      # new_admin_user_bank_account_path
      def new
        @bank_account = Spree::BankAccount.new
        respond_to do |format|
          format.html # new.html.erb
        end
      end

      # POST /admin/users/:user_id/bank_accounts
      # admin_user_bank_accounts_path
      def create
        @bank_account = Spree::BankAccount.new(bank_account_params)

        respond_to do |format|
          if @bank_account.save
            format.html { redirect_to admin_user_bank_accounts_path, notice: 'Dado Bancário criado com sucesso.' }
          else
            format.html { render action: "new" }
          end
        end
      end

      # GET /admin/users/:user_id/bank_accounts/:id/edit
      # edit_admin_user_bank_account_path
      def edit
        @bank_account = Spree::BankAccount.find(params[:id])
        @errors = []
        @errors << "Há campos obrigatórios em branco. Preencha-os, SALVE e tente novamente." if @bank_account.bank_id.nil? || @bank_account.nome.nil? || (@bank_account.cpf.nil? and @bank_account.cnpj.nil?) || @bank_account.agencia.nil? || @bank_account.conta.nil?
        respond_to do |format|
          format.html # edit.html.erb
        end
      end

      # PATCH /admin/users/:user_id/bank_accounts/:id
      # admin_user_bank_account_path
      def update
        @bank_account = Spree::BankAccount.find(params[:id])

        respond_to do |format|
          if @bank_account.update_attributes(bank_account_params)
            format.html { redirect_to admin_user_bank_accounts_path, notice: 'Dados bancários atualizados com sucesso.' }
          else
            format.html { render action: "edit" }
          end
        end
      end

      # POST /admin/users/:user_id/bank_accounts/:id/revalidate
      # revalidate_admin_user_bank_account_path
      def revalidate
        @bank_account = Spree::BankAccount.find(params[:id])

        if @bank_account.complete?
          begin
            @pagarme_data = @bank_account.get_bank_account
          rescue => e
            flash[:error] = e.message
          end
        else
          flash[:error] = "Conta Bancária está incompleta."
        end

        @bank_account.reload

        respond_to do |format|
          if @bank_account.pagarme_id.nil?
            format.js { render_js_for_destroy }
          else
            format.js { render 'check_pagarme' }
          end
        end
      end

      # POST /admin/users/:user_id/bank_accounts/:id/check_pagarme
      # check_pagarme_admin_user_bank_account_path
      def check_pagarme
        @bank_account = Spree::BankAccount.find(params[:id])

        unless @bank_account.pagarme_id.nil?
          @pagarme_data = @bank_account.get_bank_account
        end

        respond_to do |format|
          format.js
        end
      end

      private

      def load_user
        @user = Spree.user_class.find_by(id: params[:user_id])

        unless @user
          flash[:error] = Spree.t(:user_not_found)
          redirect_to admin_path
        end
      end

      def bank_account_params
        params.require(:bank_account).permit(:user_id,:bank_id,:banco,:agencia,:conta,:cpf,:nome,:obs)
      end

    end
  end
end
