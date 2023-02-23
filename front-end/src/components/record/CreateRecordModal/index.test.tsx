import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import { render } from "../../../testUtils";

import { CreateRecordModal } from ".";

const mockProps = {
  metricId: 1,
  isOpen: true,
  onClose: jest.fn(),
};

describe("CreateRecordModal", () => {
  it("renders title", () => {
    render(<CreateRecordModal {...mockProps} />);
    const title = screen.getByText("Add record");
    expect(title).toBeInTheDocument();
  });

  describe("when click on cancel button", () => {
    it("closes modal", async () => {
      render(<CreateRecordModal {...mockProps} />);

      const button = screen.getByRole("button", { name: "Cancel" });
      await userEvent.click(button);

      expect(mockProps.onClose).toHaveBeenCalled();
    });
  });

  describe("when click on submit button", () => {
    describe("with valid form values", () => {
      it("closes modal", async () => {
        render(<CreateRecordModal {...mockProps} />);

        const timestampInput = screen.getByLabelText(/Date and time/);
        const valueInput = screen.getByLabelText(/Value/);
        const submit = screen.getByRole("button", { name: "Add" });

        await userEvent.type(timestampInput, "2010-10-10 01:00:00");
        await userEvent.type(valueInput, "300");
        await userEvent.click(submit);

        expect(mockProps.onClose).toHaveBeenCalled();
      });
    });

    describe("with any invalid form value", () => {
      it("does not close modal", async () => {
        render(<CreateRecordModal {...mockProps} />);

        const submit = screen.getByRole("button", { name: "Add" });
        await userEvent.click(submit);

        expect(mockProps.onClose).not.toHaveBeenCalled();
      });
    });

    describe("with future timestamp", () => {
      it("shows error message", async () => {
        render(<CreateRecordModal {...mockProps} />);

        const timestampInput = screen.getByLabelText(/Date and time/);
        const submit = screen.getByRole("button", { name: "Add" });

        await userEvent.type(timestampInput, "3000-01-01 01:00:00");
        await userEvent.click(submit);

        const errorMessage = await screen.findByText("Must not be future");

        expect(errorMessage).toBeInTheDocument();
      });
    });

    describe("with invalid timestamp", () => {
      it("shows error message", async () => {
        render(<CreateRecordModal {...mockProps} />);

        const timestampInput = screen.getByLabelText(/Date and time/);
        const submit = screen.getByRole("button", { name: "Add" });

        await userEvent.type(timestampInput, "abc");
        await userEvent.click(submit);

        const errorMessage = await screen.findByText("Must be a valid date and time");

        expect(errorMessage).toBeInTheDocument();
      });
    });

    describe("with non-positive value", () => {
      it("shows error message", async () => {
        render(<CreateRecordModal {...mockProps} />);

        const valueInput = screen.getByLabelText(/Value/);
        const submit = screen.getByRole("button", { name: "Add" });

        await userEvent.type(valueInput, "0");
        await userEvent.click(submit);

        const errorMessage = await screen.findByText("Must be greater than or equal to 0.01");

        expect(errorMessage).toBeInTheDocument();
      });
    });

    describe("with invalid value", () => {
      it("shows error message", async () => {
        render(<CreateRecordModal {...mockProps} />);

        const valueInput = screen.getByLabelText(/Value/);
        const submit = screen.getByRole("button", { name: "Add" });

        await userEvent.type(valueInput, "abc");
        await userEvent.click(submit);

        const errorMessage = await screen.findByText("Must be a valid value");

        expect(errorMessage).toBeInTheDocument();
      });
    });
  });
});
