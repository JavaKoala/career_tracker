module SortHelper
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def change_direction
    sort_direction == 'asc' ? 'desc' : 'asc'
  end
end
