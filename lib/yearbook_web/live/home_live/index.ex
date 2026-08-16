defmodule YearbookWeb.HomeLive.Index do
  @moduledoc """
  Yearbook Page
  """
  use YearbookWeb, :landing_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Yearbook")}
  end

  def handle_event("choose_licenciatura", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/yearbook?#{%{masters: false, page: 1}}")}
  end

  def handle_event("choose_mestrado", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/yearbook?#{%{masters: true, page: 1}}")}
  end

  def handle_event("make_request", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/request")}
  end
end
