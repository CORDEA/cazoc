defmodule Cazoc.FamilyController do
  use Cazoc.Web, :controller

  alias Cazoc.Family

  plug :scrub_params, "family" when action in [:create, :update]

  def index(conn, _params) do
    families = Repo.all(Family)
    render(conn, "index.html", families: families)
  end

  def new(conn, _params) do
    changeset = Family.changeset(%Family{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"family" => family_params}) do
    changeset = Family.changeset(%Family{}, family_params)

    case Repo.insert(changeset) do
      {:ok, _family} ->
        conn
        |> put_flash(:info, "Family created successfully.")
        |> redirect(to: family_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    family = Repo.get!(Family, id)
    render(conn, "show.html", family: family)
  end

  def edit(conn, %{"id" => id}) do
    family = Repo.get!(Family, id)
    changeset = Family.changeset(family)
    render(conn, "edit.html", family: family, changeset: changeset)
  end

  def update(conn, %{"id" => id, "family" => family_params}) do
    family = Repo.get!(Family, id)
    changeset = Family.changeset(family, family_params)

    case Repo.update(changeset) do
      {:ok, family} ->
        conn
        |> put_flash(:info, "Family updated successfully.")
        |> redirect(to: family_path(conn, :show, family))
      {:error, changeset} ->
        render(conn, "edit.html", family: family, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    family = Repo.get!(Family, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(family)

    conn
    |> put_flash(:info, "Family deleted successfully.")
    |> redirect(to: family_path(conn, :index))
  end
end
