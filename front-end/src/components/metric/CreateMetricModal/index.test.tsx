import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import { render } from "../../../testUtils";

import { CreateMetricModal } from ".";

const mockProps = {
  isOpen: true,
  onClose: jest.fn(),
};

describe("CreateMetricModal", () => {
  it("renders title", () => {
    render(<CreateMetricModal {...mockProps} />);
    const title = screen.getByText("Create metric");
    expect(title).toBeInTheDocument();
  });

  describe("when click on cancel button", () => {
    it("closes modal", async () => {
      render(<CreateMetricModal {...mockProps} />);

      const button = screen.getByRole("button", { name: "Cancel" });
      await userEvent.click(button);

      expect(mockProps.onClose).toHaveBeenCalled();
    });
  });

  describe("when click on submit button", () => {
    describe("with valid form values", () => {
      it("closes modal", async () => {
        render(<CreateMetricModal {...mockProps} />);

        const input = screen.getByLabelText(/Name/);
        const submit = screen.getByRole("button", { name: "Create" });

        await userEvent.type(input, "Metric");
        await userEvent.click(submit);

        expect(mockProps.onClose).toHaveBeenCalled();
      });
    });

    describe("with any invalid form value", () => {
      it("does not close modal", async () => {
        render(<CreateMetricModal {...mockProps} />);

        const submit = screen.getByRole("button", { name: "Create" });
        await userEvent.click(submit);

        expect(mockProps.onClose).not.toHaveBeenCalled();
      });
    });

    describe("with long name", () => {
      it("shows error message", async () => {
        render(<CreateMetricModal {...mockProps} />);

        const input = screen.getByLabelText(/Name/);
        const submit = screen.getByRole("button", { name: "Create" });

        await userEvent.type(
          input,
          "metric metric metric metric metric metric metric metric metric metric metric metric",
        );
        await userEvent.click(submit);

        const errorMessage = await screen.findByText("Must be at most 30 characters");

        expect(errorMessage).toBeInTheDocument();
      });
    });
  });
});
