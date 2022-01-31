class TasksController < ApplicationController
    before_action :get_user
    before_action :get_user_project
    before_action :get_project_task, only: [:show, :update, :destroy]

    # GET /projects/:project_id/tasks
    def index
        json_response(@project.tasks)
    end

    # GET /projects/:project_id/tasks/:id
    def show
        json_response(@task)
    end

    # POST /projects/:project_id/tasks
    def create 
        @project.tasks.create!(task_params)
        json_response(@project.tasks, :created)
    end

    # PUT /projects/:project_id/tasks/:id
    def update
        @task.update(task_params)
        head :no_content
    end

    # DELETE /projects/:project_id/tasks/:id
    def destroy
        @task.destroy()
        head :no_content
    end

    private

    def task_params
        params.permit(:name, :description, :status, :deadline)
    end

    def get_user
        @user = current_user
    end

    def get_user_project
        @project = @user.projects.find_by!(id: params[:project_id]) if @user
    end

    def get_project_task
        @task = @project.tasks.find_by!(id: params[:id]) if @project
    end
end
