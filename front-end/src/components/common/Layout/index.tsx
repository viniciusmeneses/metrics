import { Box, Container, ContainerProps } from "@chakra-ui/react";

export const Layout = (props: ContainerProps) => (
  <Box bgColor="gray.50" minH="100vh">
    <Container as="main" maxW="1024px" py={10} {...props} />
  </Box>
);
