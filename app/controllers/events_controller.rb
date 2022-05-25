class EventsController < ApplicationController
  include CableReady::Broadcaster

  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
  def index
    @events = Event.all.order(created_at: :desc)
    @people = Person.order(created_at: :desc).last(5)
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    person = @event.person
    respond_to do |format|
      if @event.update(event_params)
        new_person = @event.person
        if person.present? && person != new_person
          cable_ready["dashboard"].remove(
            selector: "#event_card_#{@event.uuid}_with_person_#{person.uuid}",
            )
          cable_ready.broadcast
        end
        if new_person.present? && new_person != person
          cable_ready["dashboard"].insert_adjacent_html(
            selector: "#events_related_to_person_#{new_person.uuid}",
            position: "afterbegin",
            html: ApplicationController.render(partial: 'events/event_card', locals: { event: @event, person: new_person })
          )
          cable_ready.broadcast
        end
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    rescue
      redirect_to root_path
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :name, :birthdate, :description, :event_type)
    end
end
