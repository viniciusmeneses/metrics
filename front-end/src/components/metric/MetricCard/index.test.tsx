import { rest } from "msw";
import { PropsWithChildren } from "react";

import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import { SingleMetricReport } from "../../../api";
import { server } from "../../../mocks";
import { render } from "../../../testUtils";

import { MetricCard } from ".";

const mockProps = { metricId: 1 };

jest.mock("react-apexcharts", () => ({
  __esModule: true,
  default: (props: PropsWithChildren) => <div {...props} />,
}));

describe("MetricCard", () => {
  it("renders title", async () => {
    render(<MetricCard {...mockProps} />);
    const title = await screen.findByText("Metric");
    expect(title).toBeInTheDocument();
  });

  it("renders average", async () => {
    render(<MetricCard {...mockProps} />);
    const average = await screen.findByText("592,5 per day");
    expect(average).toBeInTheDocument();
  });

  it("renders metric chart", async () => {
    render(<MetricCard {...mockProps} />);
    const chart = await screen.findByTestId("chart");
    expect(chart).toBeInTheDocument();
  });

  describe("when click on create record button", () => {
    it("opens a modal", async () => {
      render(<MetricCard {...mockProps} />);

      const button = await screen.findByRole("button", { name: "Add record" });
      await userEvent.click(button);

      const modal = screen.getByRole("dialog");

      expect(modal).toBeInTheDocument();
    });
  });

  describe("when metric does not exist", () => {
    beforeEach(() =>
      server.use(rest.get("/reports/metrics/:metricId", (_, res, ctx) => res(ctx.status(404)))),
    );

    it("does not render anything", async () => {
      render(<MetricCard {...mockProps} />);
      await new Promise(process.nextTick);

      const title = screen.queryByText("Metric");
      expect(title).not.toBeInTheDocument();
    });
  });
});
