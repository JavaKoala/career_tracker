class CurriculumVitaesController < ApplicationController
  notifications only: %i[show new]

  def show; end

  def new
    @cv = CurriculumVitae.new
  end

  def create
    @cv = CurriculumVitae.new(cv_params)
    @cv.user = Current.user

    if @cv.save
      redirect_to curriculum_vitae_path(@cv), notice: t(:created_resume)
    else
      redirect_to new_curriculum_vitae_path, alert: @cv.errors.full_messages.join(', ')
    end
  end

  def update; end

  def destroy; end

  private

  def cv_params
    params.expect(curriculum_vitae: { resume: { basics: %i[name label] } })
  end
end
