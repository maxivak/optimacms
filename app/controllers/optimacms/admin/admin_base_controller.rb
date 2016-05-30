module Optimacms
  module Admin
    class AdminBaseController < ApplicationController
      before_action :authenticate_cms_admin_user!


      layout 'optimacms/admin/layouts/main'

      add_flash_types :success

      helper ApplicationHelper
      helper FormsHelper


      #### modal
      def set_layout_modal_old
        if @modal==1
          self.class.layout false
        end

      end


      ### devise

      def after_sign_in_path_for(resource)
        if resource.is_a?(CmsAdminUser)
          dashboard_path
        else
          root_path
        end

      end


      ### redirects
      def redirect_to_res(res)
        v_res = res ? 1 : 0
        redirect_to res_common_path(res: v_res)
      end

    end

  end
end