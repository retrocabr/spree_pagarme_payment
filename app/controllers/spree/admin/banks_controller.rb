module Spree
  module Admin
    class BanksController < Spree::Admin::BaseController

      # GET /admin/banks
      # admin_banks_path
      def index
        params[:q] ||= {}
        @search = Spree::Bank.ransack(params[:q])
        @banks = @search.result(distinct: true)

        respond_to do |format|
          format.html # index.html.erb
        end
      end

      # GET /admin/banks/new
      # new_admin_bank_path
      def new
        @bank = Spree::Bank.new
        respond_to do |format|
          format.html # new.html.erb
        end
      end

      # POST /admin/banks
      # admin_banks_path
      def create
        @bank = Spree::Bank.new(bank_params)
        
        respond_to do |format|
          if @bank.save
            format.html { redirect_to admin_banks_path, notice: 'Banco criado com sucesso.' }
          else
            format.html { render action: "new" }
          end
        end
      end

      def show
        edit
      end

      # GET /admin/banks/:id/edit
      # edit_admin_bank_path
      def edit
        @bank = Spree::Bank.find(params[:id])
        
        respond_to do |format|
          format.html # edit.html.erb
        end
      end

      # PATCH /admin/banks/:id
      # admin_bank_path
      def update
        @bank = Spree::Bank.find(params[:id])

        respond_to do |format|
          if @bank.update_attributes(bank_params)
            format.html { redirect_to admin_banks_path, notice: 'Banco atualizado com sucesso.' }
          else
            format.html { render action: "edit" }
          end
        end
      end

      private

      def bank_params
        params.require(:bank).permit(:name,:code,:bookmarked)
      end

    end
  end
end