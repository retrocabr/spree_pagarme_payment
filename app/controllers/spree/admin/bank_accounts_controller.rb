module Spree
  module Admin
    class BankAccountsController < Spree::Admin::BaseController
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

      private

      def load_user
        @user = Spree.user_class.find_by(id: params[:user_id])

        unless @user
          flash[:error] = Spree.t(:user_not_found)
          redirect_to admin_path
        end
      end

      def bank_account_params
        params.require(:bank_account).permit(:user_id,:banco,:agencia,:conta,:cpf,:nome,:obs)
      end

    end
  end
end