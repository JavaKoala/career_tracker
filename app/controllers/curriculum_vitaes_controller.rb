class CurriculumVitaesController < ApplicationController
  notifications only: %i[show new]

  def show
    @resume = Current.user&.curriculum_vitae&.resume
  end

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

  def destroy
    Current.user.curriculum_vitae&.destroy

    redirect_to settings_path, notice: t(:deleted_resume)
  end

  private

  def cv_params
    params.expect(curriculum_vitae: { resume: {
                    basics: [:name, :label, :image, :email, :phone, :summary,
                             {
                               location: %i[address postalCode city countryCode region]
                             }, profiles: [%i[network username]]],
                    work: [%i[name position]]
                  } })
  end
end
