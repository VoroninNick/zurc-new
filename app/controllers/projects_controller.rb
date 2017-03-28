class ProjectsController < InheritedResources::Base

  private

    def project_params
      params.require(:project).permit(:name, :url_fragment, :deadline_date)
    end
end

