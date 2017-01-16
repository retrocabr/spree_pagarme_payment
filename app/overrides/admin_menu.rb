Deface::Override.new(:virtual_path => "spree/admin/shared/sub_menu/_configuration",
    :name => "add_bank_settings",
    :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
    :text => "<%= configurations_sidebar_menu_item('Lista de Bancos', admin_banks_path) %>")