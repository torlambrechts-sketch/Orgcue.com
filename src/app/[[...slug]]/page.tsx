import ClientApp from '@/components/ClientApp';

// One catch-all route: the prototype is a client-rendered app with its own router (src/components/Shell.tsx).
export default function Page() {
  return <ClientApp />;
}
