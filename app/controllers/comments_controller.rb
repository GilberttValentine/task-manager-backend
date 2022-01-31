class CommentsController < ApplicationController
    before_action :get_user
    before_action :get_user_project
    before_action :get_project_task
    before_action :get_task_comment, only: [:destroy]

    # GET /projects/:project_id/tasks/:task_id/comments
    def index
        json_response(@task.comments)
    end

    # POST /projects/:project_id/tasks/:task_id/comments
    def create
        @task.comments.create!(comment_params)
        json_response(@task.comments, :created)
    end

    # DELETE /projects/:project_id/tasks/:task_id/comments/:id
    def destroy
        @comment.destroy()
        head :no_content
    end

    private

    def comment_params
        params.permit(:user_id, :description)
    end

    def get_user
        @user = current_user
    end

    def get_user_project
        @project = @user.projects.find_by!(id: params[:project_id]) if @user
    end

    def get_project_task
        @task = @project.tasks.find_by!(id: params[:task_id]) if @project
    end

    def get_task_comment
        @comment = @task.comments.find_by!(id: params[:id]) if @task
    end
end
