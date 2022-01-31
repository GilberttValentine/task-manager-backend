class ProjectsController < ApplicationController
    before_action :get_user
    before_action :get_user_project, only: [:show, :update, :destroy]

    # GET /projects
    def index
        json_response(@user.projects)
    end

    # GET /projects/:id
    def show
        json_response(@project)
    end

    # POST /projects
    def create 
        @user.projects.create!(project_params)
        json_response(@user.projects, :created)
    end

    # PUT /projects/:id
    def update
        @project.update(project_params)
        head :no_content
    end

    # DELETE /projects/:id
    def destroy
        @project.destroy
        head :no_content
    end

    private

    def project_params
        params.permit(:name, :description, :status)
    end

    def get_user
        @user = current_user
    end

    def get_user_project
        @project = @user.projects.find_by!(id: params[:id]) if @user
    end
end
