class CommentFilesController < ApplicationController
    before_action :get_user
    before_action :get_user_project
    before_action :get_project_task
    before_action :get_task_comment
    before_action :get_comment_file, only: [:show, :destroy]

    # GET /projects/:project_id/tasks/:task_id/comments/:comment_id/comment_files
    def index
        json_response(@comment.comment_files)
    end

    # GET /users/:user_id/projects/:project_id/tasks/:task_id/comments/:comment_id/comment_files/:id
    def show
        json_response(@file)
    end

    # POST /users/:user_id/projects/:project_id/tasks/:task_id/comments/:comment_id/comment_files
    def create
        @comment.comment_files.create!(file_params)
        json_response(@comment.comment_files, :created)
    end

    # DELETE /users/:user_id/projects/:project_id/tasks/:task_id/comments/:comment_id/comment_files/:id
    def destroy
        @file.destroy()
        head :no_content
    end

    private

    def file_params
        params.permit(:url)
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
        @comment = @task.comments.find_by!(id: params[:comment_id]) if @task
    end

    def get_comment_file
        @file = @comment.comment_files.find_by!(id: params[:id]) if @comment
    end
end
