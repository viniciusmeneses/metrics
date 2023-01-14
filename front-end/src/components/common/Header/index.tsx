import { Box, Button, Heading, Stack, StackProps, Text, useDisclosure } from "@chakra-ui/react";

export const Header = (props: StackProps) => {
  const createMetricModal = useDisclosure();

  return (
    <Stack direction={{ base: "column", sm: "row" }} spacing={3} {...props}>
      <Box flex="1">
        <Heading size="lg">Growth Metrics</Heading>
        <Text color="gray.500">Analyze your growth metrics with a user-friendly dashboard</Text>
      </Box>

      <Button w={{ base: "full", sm: "140px" }} onClick={createMetricModal.onOpen}>
        Create metric
      </Button>
    </Stack>
  );
};
